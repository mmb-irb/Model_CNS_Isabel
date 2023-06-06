
dirlist=(`ls Imaged_Preanaly_Trajectories`)

for pdb in "${dirlist[@]}"; do

	# Get the pdb id
	pdbid=${pdb:0:4}

	# Print the project we are about to work with
	echo $pdbid

	# Move to the project folder
	cd Imaged_Preanaly_Trajectories/$pdb/analysis_checkdynamics

	echo "Protein" "System" |gmx trjconv -s topology.tpr -f md.imaged.rot.xtc -o md.imaged.rot.xtc -fit rot+trans -quiet

	cd ../../..


done

