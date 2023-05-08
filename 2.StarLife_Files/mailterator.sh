#!/bin/bash

# Read the list of projects to iterate
dirlist=(`ls CNS_PD_Memprot_dynamics`)

# Set a counter
c=0

# Iterate over projects
for pdb in "${dirlist[@]}"; do

	# Get the pdb id
	pdbid=${pdb:0:4}

	# Print the project we are about to work with
	echo $pdbid

	# Move to the project folder
	cd CNS_PD_Memprot_dynamics/$pdb

	# Check if the 'md.cpt' file exist. If not, it is the first run.
	if [ ! -f md.cpt ]
	then
		# Run the sbatch
		echo 'Running EM'
		jobID_1=$(sbatch  sbatch_P1_script_$pdbid.sh | cut -f 4 -d' ')
		echo 'Running PR'
		jobID_2=$(sbatch --dependency=afterany:$jobID_1 sbatch_P2_script_$pdbid.sh | cut -f 4 -d' ') 
		echo 'Running 100ns'
		ijob=$(sbatch  --dependency=afterany:$jobID_2  sbatch_P3_script_$pdbid.sh | cut -f 4 -d' ')

	else 
		# Search all jobs with the name of our protein which are still queued and get the job id of the last
		previous=$(squeue -u $USER --sort=+i | grep "$pdbid" | cut -f1 -d' ' | tail -n 1)
		# Check if we had results from the last search
		if [ -z "$previous" ]
			then
			# If not, send the sbatch without any dependency
			ijob=$(sbatch  sbatch_cont_script_$pdbid.sh | cut -f 4 -d' ')
			echo "Continuing $pdbid runs:"
		else
			# If yes, send the batch with dependency to the previous job id
			ijob=$(sbatch --dependency=afterany:${previous}  sbatch_cont_script_$pdbid.sh | cut -f 4 -d' ')
	                echo "Continuing $pdbid runs after job $previous:"
		fi
	fi


# Now repeat the sbatch process as times as specified
	extraRuns=$((5)) # We want to repeat it 20 times. We expect that with 20 times for running the simulation is enough. 

	echo 'Throwing 20 more dependencies'
	for i in `seq 1 $extraRuns`; do

		# Set the sbatch dependent of the last batch to be finished
		ijob=$(sbatch -J cont_${pdbid}_$i --dependency=afterany:$ijob  sbatch_cont_script_$pdbid.sh | cut -f 4 -d' ')

	done

	# Use this to exit after a few iterations
	# (c++)) && ((c>=10)) && break

# Go back to the main directory
cd ../..
done
