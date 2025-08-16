a.out: lexer.l parser.y
	bison -d parser.y
	flex lexer.l
	g++ -o $@ parser.tab.c lex.yy.c -lfl
