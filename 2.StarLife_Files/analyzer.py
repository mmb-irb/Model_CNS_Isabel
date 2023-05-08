from model_workflow.mwf import workflow
from mdtoolbelt.structures import Structure
from mdtoolbelt.conversions import convert


# check if trajectory has hydrogens in the membrane
pdb_filename = 'test.pdb'
convert(input_structure_filename='md.tpr', input_trajectory_filenames=['md.xtc'], output_structure_filename=pdb_filename)
structure = Structure.from_pdb_file(pdb_filename)
membrane_residue = next(residue for residue in structure.residues if residue.name == 'DPPC' or residue.name == 'DPP')
hydrogen_atom = next((atom for atom in membrane_residue.atoms if atom.name[0] == 'H'), None)

print('has hydrogens: ' + str(bool(hydrogen_atom)))

# launch the workflow
# mwf -top md.tpr -traj md.xtc -char md.tpr -pr 4 -filt -i topology --trust cohbonds
workflow(
    input_topology_filename='md.tpr',
    input_trajectory_filenames=['md.xtc'],
    input_charges_filename='md.tpr',
    preprocess_protocol=4,
    filter_selection=True,
    trust=([] if hydrogen_atom else ['cohbonds']),
    include=['topology']
)