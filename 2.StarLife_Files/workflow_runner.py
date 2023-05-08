from model_workflow.mwf import workflow
from mdtoolbelt.structures import Structure

from os import listdir, chdir, remove
from os.path import exists

# Get all simulations in current directory
# DANI: Cuidado porque listdir te coge también el script, que no es un directorio
simulations = [ d for d in listdir() if d != 'workflow_runner.py' ]

# Set a file that, if exists, it means we are done already
sample_file = 'metadata.json'

for simulation in simulations:
    # We go to the sirectory where the actual data is
    chdir(simulation + '/analysis_checkdynamics')
    remove('topology.json')
    # if exists(sample_file):
    #     chdir('../..')
    #     continue
    print(simulation)
    # We check data is present
    structure_filename = 'md.imaged.rot.dry.pdb'
    if not exists(structure_filename):
        chdir('../..')
        continue
    # We fix the chains
    structure = Structure.from_pdb_file(structure_filename)
    protein_selection = structure.select('protein', syntax='vmd')
    membrane_selection = structure.select('not protein', syntax='vmd')
    structure.chainer(membrane_selection, 'M')
    structure.chainer(protein_selection, 'X')
    # Set chains by fragment
    structure.chainer(protein_selection)
    structure.generate_pdb_file(structure_filename)
    # Run the whole workflow
    # We skip all analyses since at this point they have been run already
    try:
        workflow(trust=True)
    except Exception as e:
        print(str(e))
    # We go back
    chdir('../..')
