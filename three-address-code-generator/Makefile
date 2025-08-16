a.out: parser.tab.c lex.yy.c
	g++ -O3 lex.yy.c parser.tab.c

parser.tab.c: parser.y
	bison -d parser.y

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

clean:
	@rm lex.yy.c parser.tab.h parser.tab.c a.exe