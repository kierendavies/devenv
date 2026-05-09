if set -q WSLENV
    set -gx COLORTERM truecolor
    set -gx GALLIUM_DRIVER d3d12
    set -gx LIBVA_DRIVER_NAME d3d12
end
