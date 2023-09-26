#!/usr/bin/env bash
# This script allows Staff software engineers to review and provide feedback on code.

# Provide documentation and usage notes
usage() {
	echo "Usage: $0 <script_path> [<feedback_hints>]"
	echo "	* <script_path>: the path to the script to be reviewed"
	echo "	* <feedback_hints>: optional, hints for the reviewer (e.g. -d for documentation, -u for usage notes)"
	exit 1
}

if [ $# -eq 0 ]; then
	usage
fi

# Set default
SCRIPT=$1
HINTS=$2

# Check number of arguments

# Persist the review to revisit later
BASENAME=$(basename $0 .sh)
PROMPTS_BASE=~/.$BASENAME

# Generate a unique timestamp
timestamp=$(date +"%Y%m%d_%H%M%S")
FEEDBACK_DIR=$PROMPTS_BASE/$timestamp
mkdir -p $FEEDBACK_DIR

# Use the timestamp in the file name or wherever needed
input_file="code_review_prompt_$timestamp.txt"
output_file="code_review_output_$timestamp.txt"

echo $FEEDBACK_DIR/$input_file
echo "========================="

# https://ollama.ai/library/codellama
# https://ollama.ai/library/llama2
# OLLAMA_MODEL_VERSION=2
MODEL_VERSION=6
MODEL="staff-engineers-$MODEL_VERSION"

if [ -f $SCRIPT ]; then
	cat $SCRIPT >$FEEDBACK_DIR/$input_file
	ollama run --diff --all $MODEL "$(cat $FEEDBACK_DIR/$input_file)" "Show the final script with proposed name and all suggested changes." | tee $FEEDBACK_DIR/$output_file
	echo "========================="
	echo $FEEDBACK_DIR/$output_file
else
	echo "$SCRIPT not found"
fi
