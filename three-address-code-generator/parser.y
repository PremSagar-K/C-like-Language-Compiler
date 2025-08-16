%{
    #include <bits/stdc++.h>
    using namespace std;

    extern char* yytext;

    void yyerror(const char *);
    int yylex(void);
    int t_no = 1;
    int l_no = 1;
    int param_count = 1;
    bool is_global = true;
    bool isCond = false;
    bool isForassign = false;
    set<string> scope;
    set<string> global_scope;
    stack<set<string>> S_scope;
    vector<string> V_params;
    stack<vector<string>> S; // params stack


    vector<string> temp;

    class Node
    {
        public:
        string value;
        string label;
        vector<string> V;
        Node *left, *right, *parent;

        Node() : left(nullptr), right(nullptr), parent(nullptr) {}
    };
    vector<pair<string, Node*>> V;
    stack<vector<pair<string, Node*>>> V_stack;
    stack<Node*> nodeStack;

    int if_no = 0;
    int cont_no = 0;
    stack<int> if_nos;
    stack<int> cont_nos;

Node* find_and(Node* node)
{
    while(node->parent != nullptr)
    {
        if(node->parent->value == "&&" && node->parent->left == node)
        {
            Node* temp = node->parent->right;
            while(temp->left != nullptr)
            {
                temp = temp->left;
            }
            return temp;
        }
        node = node->parent;
    }
    return nullptr;
}

Node* find_or(Node* node)
{
    while(node->parent != nullptr)
    {
        if(node->parent->value == "||" && node->parent->left == node)
        {
            Node* temp = node->parent->right;
            while(temp->left != nullptr)
            {
                temp = temp->left;
            }
            return temp;
        }
        node = node->parent;
    }
    return nullptr;
}

void put_not(Node* node)
{
    if(node->value == "&&")
    {
        node->value = "||";
        put_not(node->left);
        put_not(node->right);
    }
    else if(node->value == "||")
    {
        node->value = "&&";
        put_not(node->left);
        put_not(node->right);
    }
    else
    {
        string temp = "t" + to_string(t_no) + " = " + node->value;
        node->V.push_back(temp);
        node->value = string("not ") + "t" + to_string(t_no);
        t_no++;
    }    
}

%}

%union
{
    char* strval;
    int intval;
}

%token<strval> NAME STRING_INP COND AND OR CHAR_INP
%token MAIN IF ELSE FOR WHILE RETURN INT CHAR POW 

%token<intval> NUM
%type<strval> expr identifier funccall cond code_binder

%left OR
%left AND
%left '+' '-'
%left '*' '/'
%right POW


%start program

%%
program: INT MAIN {cout << endl << "main:" << endl; is_global = false; scope.clear(); S_scope.push(scope);} '(' ')' '{' body '}' {is_global = true; S_scope.pop();}
    |   decl ';' program
    |   func program

func: INT NAME {param_count = 1; cout << endl << $2 << ":" << endl; is_global = false; scope.clear(); S_scope.push(scope);} '('  args ')' '{' body '}' {is_global = true; S_scope.pop();}

args: 
    |   singlearg
    |   singlearg ',' args
;

singlearg: 
    |   INT NAME {cout << $2 << " = param" << param_count << endl; param_count++; S_scope.top().insert($2);}
;

body: line {}
    |   body line {}

line: decl ';' | assgn ';' | funccall ';' | ifelse | for | while | return ';'

decl: INT NAME {if(is_global) {cout << "global " << $2 << endl; global_scope.insert($2);} else S_scope.top().insert($2);}
    | INT NAME {if(is_global){cout << "global " << $2 << endl; global_scope.insert($2);} else S_scope.top().insert($2);} '=' expr 
    {
        if ($5[0] != 't')
            {
                cout << "t" << t_no << " = " << $5 << endl;
                cout << $2 << " = t" << t_no << endl;
                t_no++;
            }
        else
            cout << $2 << " = " << $5 << endl;
    }
    | CHAR NAME '[' NUM ']' 
    {
        if(is_global)
        {
            cout << "global " << $2 << "[" << $4 << "]" << endl;
            global_scope.insert(string($2) + "[" + to_string($4) + "]");
        }
        else
        {
            S_scope.top().insert(string($2) + "[" + to_string($4) + "]");
        }
    }
    | CHAR NAME '[' NUM ']' '=' STRING_INP 
    | CHAR NAME '[' NUM ']' '=' CHAR_INP 
    {
        if(is_global)
        {
            cout << "global " << $2 << "[" << $4 << "]" << endl;
            global_scope.insert(string($2) + "[" + to_string($4) + "]");
        }
        else
        {
            S_scope.top().insert(string($2) + "[" + to_string($4) + "]");
        }
        cout << "t" << t_no << " = " << $7 << endl;
        cout << $2 << "[" << $4 << "]" << " = " << "t" << t_no << endl;
        t_no++;
    }

expr: identifier        { $$ = strdup($1); if(S_scope.top().find($1) == S_scope.top().end() && global_scope.find($1) == global_scope.end()) {cerr << "error: undeclared variable " << $1 << endl; exit(1);}}
    |   funccall        { $$ = strdup("retval"); }
    |   '(' expr ')'    { $$ = strdup($2); }
    |   NUM             { $$ = strdup(to_string($1).c_str()); }
    |   STRING_INP      { $$ = strdup($1); }
    | CHAR_INP          { $$ = strdup($1); }
    |   expr '+' expr   
    { 
        if(! isCond)
        {
            cout << "t" << t_no << " = " << $1 << " + " << $3 << endl;
        }
        else  
        {
            temp.push_back("t" + to_string(t_no) + " = " + $1 + " + " + $3);
        }
            $$ = strdup(("t" + to_string(t_no++)).c_str());
    }
    |   expr '-' expr   
    { 
        if(! isCond)
        {
            cout << "t" << t_no << " = " << $1 << " - " << $3 << endl; 
        }
        else
        {
            temp.push_back("t" + to_string(t_no) + " = " + $1 + " - " + $3);
        }
            $$ = strdup(("t" + to_string(t_no++)).c_str());
    }
    |   expr '*' expr   
    { 
        if(! isCond)
        {
            cout << "t" << t_no << " = " << $1 << " * " << $3 << endl; 
        }
        else
        {
            temp.push_back("t" + to_string(t_no) + " = " + $1 + " * " + $3);
        }
            $$ = strdup(("t" + to_string(t_no++)).c_str());
    }
    |   expr '/' expr   
    { 
        if(! isCond)
        {
            cout << "t" << t_no << " = " << $1 << " / " << $3 << endl; 
        }
        else
        {
            temp.push_back("t" + to_string(t_no) + " = " + $1 + " / " + $3);
        }   
            $$ = strdup(("t" + to_string(t_no++)).c_str());
    }
    |   expr POW expr   
    { 
        if(! isCond)
        {
            cout << "t" << t_no << " = " << $1 << " ** " << $3 << endl; 
        } 
        else
        {
            temp.push_back("t" + to_string(t_no) + " = " + $1 + " ** " + $3);
        }        
            $$ = strdup(("t" + to_string(t_no++)).c_str());
    }

assgn: identifier '=' expr 
    {
        string str = $1;
        string substr = "[";
        if(!(str.find(substr) != std::string::npos))
        if(S_scope.top().find($1) == S_scope.top().end() && global_scope.find($1) == global_scope.end())
        {
            cerr << "error: undeclared variable " << $1 << endl;
            exit(1);
        }

        if (strcmp($3, "retval") == 0 || $3[0] == 't')
        {
            if(isForassign)
                temp.push_back(string($1) + " = " + string($3));
            else
            cout << $1 << " = " << $3 << endl;
        }
        else
        {
            if(! isForassign)
            {
                cout << "t" << t_no << " = " << $3 << endl;
                cout << $1 << " = t" << t_no << endl;
                t_no++;
            }
            else
            {
                temp.push_back(string($1) + " = t" + to_string(t_no));
                temp.push_back("t" + to_string(t_no) + " = " + string($3));
                t_no++;
            }
        }
    }

identifier: NAME { $$ = strdup($1); }
    |   NAME '[' expr ']' 
    {
        string temp = std::string($1) + "[" + string($3) + "]";
        $$ = strdup(temp.c_str());
    }

funccall: NAME {V_params.clear(); S.push(V_params);} '(' params ')' 
    {
        V_params = S.top();
        S.pop();
        for (int i = 0; i < V_params.size(); i++)
        {
            cout << "param" << i + 1 << " = " << V_params[i] << endl;
        }
        cout << "call " << $1 << endl;
    }
params: 
    |   expr 
        {
            if($1[0] != 't') 
            {
                cout << "t" << t_no << " = " << $1 << endl;
                S.top().push_back("t" + to_string(t_no));
                t_no++;
            }
            else
            {
                S.top().push_back($1);
            }
        }
    |   params ',' expr
        {
            if($3[0] != 't') 
            {
                cout << "t" << t_no << " = " << $3 << endl;
                S.top().push_back("t" + to_string(t_no));
                t_no++;
            } 
            else
            {
                S.top().push_back($3);
            }
        }

ifelse: 
    | if_ 
    | if_ ELSE statement {cout << "L" << l_no << ":" << endl; l_no++;}
;

if_ : IF '(' {isCond = true; temp.clear(); V.clear(); V_stack.push(V);} cond ')' 
        {
            isCond = false;
            V = V_stack.top();
            if_no = l_no - V.size() - 1;
            cont_no = if_no + 1;
            if_nos.push(if_no);
            cont_nos.push(cont_no);
            for(auto i : V)
            {
                Node* node = i.second;
                if(node != V.begin()->second)
                cout << node->label << ":" << endl;

                vector<string> vec = node->V;
                for(auto j : vec)
                {
                    cout << j << endl;
                }

                cout << "t" << t_no << " = " << node->value << endl;
                t_no++;
                
                // if right
                cout << "if " << "(" << "t" << t_no - 1 << ")" << " goto " ;
                if(find_and(node) != nullptr)
                {
                    cout << find_and(node)->label << endl;
                }
                else
                {
                    cout << "L" << if_no << endl;
                }

                // if wrong
                cout << "goto ";
                if(find_or(node) != nullptr)
                {
                    cout << find_or(node)->label << endl;
                }
                else
                {
                    cout << "L" << cont_no << endl;
                }
            }
            V_stack.pop();
            cout << "L" << if_no << ":" << endl;
            nodeStack.pop();
        } statement {cout << "L" << cont_nos.top() << ":" << endl; if_nos.pop(); cont_nos.pop();}
;

cond: expr COND expr 
        {
            if (nodeStack.empty())
            {
                Node* node = new Node();
                node->value = string($1) + " " + string($2) + " " + string($3);
                node->V = temp;
                temp.clear();
                l_no += 2; // for true and false
                V_stack.top().push_back(make_pair("L" + to_string(l_no), node));
                nodeStack.push(node);
            }
            else
            {
                Node* node = nodeStack.top();
                node->value = string($1) + " " + string($2) + " " + string($3);
                node->V = temp;
                temp.clear();
                nodeStack.pop();
                V_stack.top().push_back(make_pair("L" + to_string(l_no), node));
                node->label = "L" + to_string(l_no);
                l_no++;
                nodeStack.push(node);
            }
        }
    | cond code_binder expr COND expr 
        {
            Node* node = new Node();
            node->value = $2;
            node->left = nodeStack.top();
            node->left->parent = node;
            node->right = new Node();
            node->right->value = string($3) + " " + string($4) + " " + string($5);
            node->right->V = temp;
            temp.clear();
            node->right->parent = node;
            nodeStack.pop();
            V_stack.top().push_back(make_pair("L" + to_string(l_no), node->right));
            node->right->label = "L" + to_string(l_no);
            l_no++;
            nodeStack.push(node);
        }
    | cond code_binder '!' expr COND expr
        {
            Node* node = new Node();
            node->value = $2;
            node->left = nodeStack.top();
            node->left->parent = node;
            node->right = new Node();
            node->right->value = string($4) + " " + string($5) + " " + string($6);
            node->right->V = temp;
            temp.clear();
            node->right->parent = node;
            nodeStack.pop();
            V_stack.top().push_back(make_pair("L" + to_string(l_no), node->right));
            node->right->label = "L" + to_string(l_no);
            l_no++;
            nodeStack.push(node);
            put_not(node->right);
        }
    | cond code_binder '!' '(' expr COND expr ')'
        {
            Node* node = new Node();
            node->value = $2;
            node->left = nodeStack.top();
            node->left->parent = node;
            node->right = new Node();
            node->right->value = string($5) + " " + string($6) + " " + string($7);
            node->right->V = temp;
            temp.clear();
            node->right->parent = node;
            nodeStack.pop();
            V_stack.top().push_back(make_pair("L" + to_string(l_no), node->right));
            node->right->label = "L" + to_string(l_no);
            l_no++;
            nodeStack.push(node);
            put_not(node->right);
        }
    | '!' cond 
        {
            put_not(V_stack.top().back().second);
        }
    | '(' cond ')' { $$ = $2; }
;

code_binder: AND { $$ = $1; }
    | OR { $$ = $1; }

for: FOR '(' fordecl ';' {isCond = true; temp.clear(); V.clear(); V_stack.push(V);} forcond ';' {isForassign = true; temp.clear();} forassgn ')'
        {
            isForassign = false;
            isCond = false;
            V = V_stack.top();
            if_no = l_no - V.size() - 1;
            cont_no = if_no + 1;
            if_nos.push(if_no);
            cont_nos.push(cont_no);
            cout << "L" << l_no << ":" << endl;
            l_no++;
            for(auto i : V)
            {
                Node* node = i.second;
                if(node != V.begin()->second)
                cout << node->label << ":" << endl;

                vector<string> vec = node->V;
                for(auto j : vec)
                {
                    cout << j << endl;
                }

                cout << "t" << t_no << " = " << node->value << endl;
                t_no++;
                
                // if right
                cout << "if " << "(" << "t" << t_no - 1 << ")" << " goto " ;
                if(find_and(node) != nullptr)
                {
                    cout << find_and(node)->label << endl;
                }
                else
                {
                    cout << "L" << if_no << endl;
                }

                // if wrong
                cout << "goto ";
                if(find_or(node) != nullptr)
                {
                    cout << find_or(node)->label << endl;
                }
                else
                {
                    cout << "L" << cont_no << endl;
                }
            }
            V_stack.pop();
            cout << "L" << if_no << ":" << endl;
            nodeStack.pop();
        } statement 
        {
            // for inc or dec assignments
            for(auto i : temp)
            {
                cout << i << endl;
            }
            temp.clear();
            cout << "goto" << " L" << l_no - 1 << endl;
            cout << "L" << cont_no << ":" << endl;
        }

fordecl:
    |   assgn
    |   decl

forcond:
    |   cond

forassgn:
    |   assgn

while: WHILE {isCond = true; temp.clear(); V.clear(); V_stack.push(V);} '(' cond ')' 
        {
            isCond = false;
            V = V_stack.top();
            if_no = l_no - V.size() - 1;
            cont_no = if_no + 1;
            if_nos.push(if_no);
            cont_nos.push(cont_no);
            cout << "L" << l_no << ":" << endl;
            l_no++;
            for(auto i : V)
            {
                Node* node = i.second;
                if(node != V.begin()->second)
                cout << node->label << ":" << endl;

                vector<string> vec = node->V;
                for(auto j : vec)
                {
                    cout << j << endl;
                }

                cout << "t" << t_no << " = " << node->value << endl;
                t_no++;
                
                // if right
                cout << "if " << "(" << "t" << t_no - 1 << ")" << " goto " ;
                if(find_and(node) != nullptr)
                {
                    cout << find_and(node)->label << endl;
                }
                else
                {
                    cout << "L" << if_no << endl;
                }

                // if wrong
                cout << "goto ";
                if(find_or(node) != nullptr)
                {
                    cout << find_or(node)->label << endl;
                }
                else
                {
                    cout << "L" << cont_no << endl;
                }
            }
            V_stack.pop();
            cout << "L" << if_no << ":" << endl;
            nodeStack.pop();
        } statement {cout << "goto" << " L" << if_nos.top() + V.size() + 1 << endl; cout << "L" << cont_nos.top() << ":" << endl; if_nos.pop(); cont_nos.pop();}

statement: line
    |   '{' body '}'

return: RETURN {cout << "return" << endl;}
    |   RETURN expr {cout << "retval = " << $2 << endl; cout << "return" << endl;}

%%
        

void printTree(Node* node, const string& prefix = "", bool isLeft = true) {
    if (node != nullptr) {
        cout << prefix << (isLeft ? "├── " : "└── ") << node->value << " " << endl;
        printTree(node->left, prefix + (isLeft ? "│   " : "    "), true);
        printTree(node->right, prefix + (isLeft ? "│   " : "    "), false);
    }
}

void yyerror(const char* s)
{
    fprintf(stderr, "%s\n", s);
    exit(1);
}

int main()
{
    S_scope.push(scope);
    V_stack.push(V);
    yyparse();

    if(!nodeStack.empty())
    printTree(nodeStack.top());

    /* for(auto i : V)
    {
        cout << i.first << " " << i.second->value << endl;
    } */
    return 0;
}