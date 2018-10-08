.PHONY: clean data

#################################################################################
# GLOBALS                                                                       #
#################################################################################

PROJECT_NAME = tj_kaggle_ga
ifeq ($(OS),Windows_NT) 
    detected_OS := Windows
else
    detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
endif


#################################################################################
# COMMANDS                                                                      #
#################################################################################

## Set up python interpreter environment
create_environment:
	conda env create --name $(PROJECT_NAME) --file environment.yml
		@echo ">>> New conda env created"

## Install Python Dependencies
update_environment:
	conda env update --name $(PROJECT_NAME) --file environment.yml

## Install Python Dependencies
export_environment:
	conda env export --name $(PROJECT_NAME) | grep -v "^prefix: " > environment.yml

## Fetch dataset
fetch_data:
	kaggle competitions download -p data/raw ga-customer-revenue-prediction
	python -m zipfile -e data/raw/sample_submission.csv.zip data/raw/
	python -m zipfile -e data/raw/test.csv.zip data/raw/
	python -m zipfile -e data/raw/train.csv.zip data/raw/
	rm data/raw/sample_submission.csv.zip
	rm data/raw/test.csv.zip
	rm data/raw/train.csv.zip

## Make Dataset
make_data:
	src/data/make_dataset.py

## Delete all compiled Python files
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete


#################################################################################
# PROJECT RULES                                                                 #
#################################################################################



#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

# Inspired by <http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html>
# sed script explained:
# /^##/:
# 	* save line in hold space
# 	* purge line
# 	* Loop:
# 		* append newline + line to hold space
# 		* go to next line
# 		* if line starts with doc comment, strip comment character off and loop
# 	* remove target prerequisites
# 	* append hold space (+ newline) to line
# 	* replace newline plus comments by `---`
# 	* print line
# Separate expressions are necessary because labels cannot be delimited by
# semicolon; see <http://stackoverflow.com/a/11799865/1968>
.PHONY: help
help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')
