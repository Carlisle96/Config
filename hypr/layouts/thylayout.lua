local M = {}

local function box(x, y, w, h)
    return { x = x, y = y, w = w, h = h }
end

local function center(area, factor)
    local width = area.w * factor
    return box(area.x + (area.w - width) / 2, area.y, width, area.h)
end

local function fallback(ctx)
    for i, target in ipairs(ctx.targets) do
        target:place(ctx:column(i, #ctx.targets))
    end
end

local function recalculate(ctx)
    if #ctx.targets == 1 then
        ctx.targets[1]:place(center(ctx.area, 0.7))
        return
    end

    fallback(ctx)
end

function M.setup()
    hl.layout.register("thylayout", {
        recalculate = recalculate,
    })
end

return M
