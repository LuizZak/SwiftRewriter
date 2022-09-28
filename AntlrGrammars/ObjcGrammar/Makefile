generate:
	antlr4 \
	-Dlanguage=Swift \
	-visitor \
	-lib ObjectiveCLexer.g4 ObjectiveCParser.g4 two-step-processing/ObjectiveCLexer.g4 two-step-processing/ObjectiveCPreprocessorLexer.g4 two-step-processing/ObjectiveCPreprocessorParser.g4 \
	-o gen -Xexact-output-dir
