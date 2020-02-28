
#Begin clock constraint
define_clock -name {latticehx1k|clk_in} {p:latticehx1k|clk_in} -period 13.912 -clockgroup Autoconstr_clkgroup_0 -rise 0.000 -fall 6.956 -route 0.000 
#End clock constraint

#Begin clock constraint
define_clock -name {latticehx1k_pll|PLLOUTCORE_derived_clock} {n:latticehx1k_pll|PLLOUTCORE_derived_clock} -period 13.912 -clockgroup Autoconstr_clkgroup_0 -rise 0.000 -fall 6.956 -route 0.000 
#End clock constraint
