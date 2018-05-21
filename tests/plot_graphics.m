#!/usr/local/bin/wolfram -script

Export["plot_graphics_output.svg", Plot[{Sin[x], Sin[2 x], Sin[3 x]}, {x, 0, 2 Pi},                                                                       
        PlotLegends -> "Expressions"]];


