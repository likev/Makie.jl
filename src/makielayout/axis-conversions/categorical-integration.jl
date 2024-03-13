"""
    CategoricalConversion(; sortby=identity)
Categorical conversion. Gets chosen automatically only for Strings right now.
The categories work with any sortable value though, so one can always do `Axis(fig; xticks=CategoricalConversion())`,
to use it for other categories.
One can use `CategoricalConversion(sortby=func)`, to change the sorting, or make unsortable objects sortable.

# Examples

```julia
# Ticks get chosen automatically as categorical
scatter(1:4, ["a", "b", "c", "a"])

# Explicitely set them for other types:

struct Test
    value
end

conversion = CategoricalConversion(sortby=x->x.value)
xtickformat = x-> string.(getfield.(x, :value)) .* " val"
barplot(Test.([:a, :b, :c]), rand(3), axis=(x_dim_conversion=conversion, xtickformat=xtickformat))
```
"""
struct CategoricalConversion <: AxisConversion
    sets::Dict{Observable,Set{Any}}
    category_to_int::Observable{Dict{Any,Int}}
    int_to_category::Vector{Pair{Int,Any}}
    sortby::Union{Nothing,Function}
end

function CategoricalConversion(; sortby=nothing)
    return CategoricalConversion(Dict{Observable,Set{Any}}(),
                              Observable(Dict{Any,Int}(); ignore_equal_values=true),
                              Pair{Int,Any}[],
                              sortby)
end

needs_tick_update_observable(conversion::CategoricalConversion) = conversion.category_to_int
MakieCore.can_axis_convert_type(::Type{Categorical}) = true
axis_conversion_type(::Type{Categorical}) = CategoricalConversion(; sortby=identity)

function recalculate_categories!(conversion::CategoricalConversion)
    all_categories = []
    for set in values(conversion.sets)
        union!(all_categories, set)
    end
    if !isnothing(conversion.sortby)
        sort!(all_categories; by=conversion.sortby)
    end
    empty!(conversion.category_to_int[])
    empty!(conversion.int_to_category)
    i2c = pairs(all_categories)
    append!(conversion.int_to_category, i2c)
    return merge!(conversion.category_to_int[], Dict(reverse(p) for p in i2c))
end


get_values(x) = x
get_values(x::Categorical) = x.values

function convert_axis_value(conversion::CategoricalConversion, value::Categorical)
    return getindex.(Ref(conversion.category_to_int[]), get_values(value))
end

function convert_axis_value(conversion::CategoricalConversion, value)
    if !haskey(conversion.category_to_int[], value)
        set = get!(() -> Set(), conversion.sets, Observable(nothing))
        push!(set, value)
        recalculate_categories!(conversion)
        notify(conversion.category_to_int)
    end
    return conversion.category_to_int[][value]
end

function convert_axis_dim(conversion::CategoricalConversion, values_obs::Observable)
    prev_values = Set{Any}()
    # This is a bit tricky...
    # We need to recalculate the categories on each values_obs update,
    # but we also need to update the cat->int mapping each time the categories get recalculated
    # So category_to_int needs to be notified every time values_obs introduces new categories
    # but we don't want to recalculate cat->int two times, when value changes + category_to_int
    # so we introduce a placeholder observable that gets triggered when an update is needed
    # outside of category_to_int updating
    update_needed = Observable(nothing)
    on(values_obs; update=true) do values
        new_values = Set(get_values(values))
        if new_values != prev_values
            conversion.sets[values_obs] = new_values
            prev_values = new_values
            recalculate_categories!(conversion)
            notify(conversion.category_to_int)
        else
            # If values doesn't introduce new categories,
            # it still may need updating (["a", "a", "b"] -> ["a", "b"])
            # If we'd really clever, we'd also track prev_values not as a set
            notify(update_needed)
        end
        return
    end

    # So now we update when either category_to_int changes, or
    # when values changes and an update is needed
    values_num = map(update_needed, conversion.category_to_int) do _, categories
        return getindex.((categories,), get_values(values_obs[]))
    end

    return values_num
end

function get_ticks(conversion::CategoricalConversion, ticks, scale, formatter, vmin, vmax)
    scale != identity && error("Scale $(scale) not supported for categorical conversion")
    labels = if ticks isa Automatic
        # TODO, do we want to support leaving out conversion? Right now, every category will become a tick
        # Maybe another function like filter?
        last.(conversion.int_to_category)
    else
        ticks
    end
    # TODO filter out ticks greater vmin vmax?
    numbers = convert_axis_value.(Ref(conversion), labels)
    labels_str = formatter isa Automatic ? string.(labels) : get_ticklabels(formatter, labels)
    return numbers, labels_str
end