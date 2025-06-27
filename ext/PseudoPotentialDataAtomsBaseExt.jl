module PseudoPotentialDataAtomsBaseExt
using AtomsBase
using PseudoPotentialData
import PseudoPotentialData: recommended_cutoff

"""
    recommended_cutoff(family::PseudoFamily, system::AbstractSystem)

Return the recommended kinetic energy cutoff, supersampling and density cutoff
for this `system`. Values may be `missing` if the respective data cannot be determined.
"""
function recommended_cutoff(family::PseudoFamily, system::AbstractSystem)
    function get_maximum(property)
        maximum(system) do atom
            getproperty(recommended_cutoff(family, element_symbol(atom)), property)
        end
    end

    (; :Ecut          => get_maximum(:Ecut),
       :supersampling => get_maximum(:supersampling),
       :Ecut_density  => get_maximum(:Ecut_density))
end

end
