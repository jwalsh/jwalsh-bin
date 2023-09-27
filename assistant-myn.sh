#!/usr/bin/env bash
# This script allows Myn to supply answers.

# Function that provides documentation and usage notes
usage() {
	echo "Usage: $0 <input_path> [<feedback_hints>]"
	echo "	* <input_path>: the path to the script to be reviewed"
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
PROMPT_FILE="prompt.txt"
OUTPUT_FILE="output.txt"

# Set the version of the model
MODEL_VERSION=2
MODEL="assistant-myn-$MODEL_VERSION"

# If the script file exists, pass its content to the Ollama model and save the outputs
if [ -f $SCRIPT_PATH ]; then
	echo "# $FEEDBACK_HINTS" >$REVIEW_DIR/$PROMPT_FILE
	cat $SCRIPT_PATH >>$REVIEW_DIR/$PROMPT_FILE
	ollama run $MODEL "# $FEEDBACK_HINTS" "$(head -n 1500 $SCRIPT_PATH)" | tee $REVIEW_DIR/$OUTPUT_FILE
	echo "=========================" | tee $REVIEW_DIR/$OUTPUT_FILE
	echo "RUN: ollama run $MODEL  \"# $FEEDBACK_HINTS\" \"\$(head -n 1500 $SCRIPT_PATH)\"" | tee $REVIEW_DIR/$OUTPUT_FILE
	echo "PROMPT: $REVIEW_DIR/$PROMPT_FILE" | tee $REVIEW_DIR/$OUTPUT_FILE
	echo "OUTPUT: $REVIEW_DIR/$OUTPUT_FILE" | tee $REVIEW_DIR/$OUTPUT_FILE
	echo "FEEDBACK_HINTS: $FEEDBACK_HINTS" | tee $REVIEW_DIR/$OUTPUT_FILE
	echo "MODEL: $MODEL" | tee $REVIEW_DIR/$OUTPUT_FILE
else
	echo "$SCRIPT_PATH not found"
fi
