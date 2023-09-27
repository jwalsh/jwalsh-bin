#!/usr/bin/env bash
# This script allows Staff software engineers to review and provide feedback on code.

# Function that provides documentation and usage notes
usage() {
	echo "Usage: $0 <script_path> [<feedback_hints>]"
	echo "	* <script_path>: the path to the script to be reviewed"
	echo "	* <feedback_hints>: optional, hints for the reviewer (e.g. -d for documentation, -u for usage notes)"
	exit 1
}

# If no arguments provided, display the usage
if [ $# -eq 0 ]; then
	usage
fi

# Set SCRIPT as first argument and HINTS as second (optional)
SCRIPT_PATH=$1
FEEDBACK_HINTS=$2

# Create the directory for saving reviews, with basename of the current script
BASENAME=$(basename $0 .sh)
SAVED_REVIEWS_DIR=~/.${BASENAME}

# Generate a unique timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
REVIEW_DIR=$SAVED_REVIEWS_DIR/$TIMESTAMP
mkdir -p $REVIEW_DIR

# Create filenames for review prompt and output, using the timestamp
PROMPT_FILE="code_review_prompt.txt"
OUTPUT_FILE="code_review_output.txt"

# Set the version of the model
MODEL_VERSION=24
MODEL="staff-engineers-$MODEL_VERSION"

# If the script file exists, pass its content to the Ollama model and save the outputs
if [ -f $SCRIPT_PATH ]; then
	echo "# $FEEDBACK_HINTS" >$REVIEW_DIR/$PROMPT_FILE
	cat $SCRIPT_PATH >>$REVIEW_DIR/$PROMPT_FILE
	ollama run $MODEL "$(cat $REVIEW_DIR/$PROMPT_FILE)" | tee $REVIEW_DIR/$OUTPUT_FILE
	echo "========================="
	echo "PROMPT: $REVIEW_DIR/$PROMPT_FILE"
	echo "OUTPUT: $REVIEW_DIR/$OUTPUT_FILE"
	echo "FEEDBACK_HINTS: $FEEDBACK_HINTS"
	echo "MODEL: $MODEL"
else
	echo "$SCRIPT_PATH not found"
fi
