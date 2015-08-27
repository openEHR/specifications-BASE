//
// grammar defining ODIN terminal value types, including atoms, lists and intervals
//

parser grammar odin_values;

string_value : STRING ;
string_list_value : string_value ( ( ',' string_value )+ | SYM_LIST_CONTINUE ) ;

integer_value : ( '+' | '-' )? INTEGER ;
integer_list_value : integer_value ( ( ',' integer_value )+ | SYM_LIST_CONTINUE ) ;
integer_interval_value :
      '|' '>'? integer_value SYM_INTERVAL_SEP '<'? integer_value '|'
    | '|' RELOP? integer_value '|'
    ;

real_value : ( '+' | '-' )? REAL ;
real_list_value : real_value ( ( ',' real_value )+ | SYM_LIST_CONTINUE ) ;
real_interval_value :
      '|' '>'? real_value SYM_INTERVAL_SEP '<'? real_value '|'
    | '|' RELOP? real_value '|'
    ;

boolean_value : SYM_TRUE | SYM_FALSE ;
boolean_list_value : boolean_value ( ( ',' boolean_value )+ | SYM_LIST_CONTINUE ) ;

character_value : CHARACTER ;
character_list_value : character_value ( ( ',' character_value )+ | SYM_LIST_CONTINUE ) ;

date_value : ISO8601_DATE ;
date_list_value : date_value ( ( ',' date_value )+ | SYM_LIST_CONTINUE ) ;
date_interval_value :
      '|' '>'? date_value SYM_INTERVAL_SEP '<'? date_value '|'
    | '|' relop? date_value '|'
    ;

time_value : ISO8601_TIME ;
time_list_value : time_value ( ( ',' time_value )+ | SYM_LIST_CONTINUE ) ;
time_interval_value :
      '|' '>'? time_value SYM_INTERVAL_SEP '<'? time_value '|'
    | '|' relop? time_value '|'
    ;

date_time_value : ISO8601_DATE_TIME ;
date_time_list_value : date_time_value ( ( ',' date_time_value )+ | SYM_LIST_CONTINUE ) ;
date_time_interval_value :
      '|' '>'? date_time_value SYM_INTERVAL_SEP '<'? date_time_value '|'
    | '|' relop? date_time_value '|'
    ;

duration_value : ISO8601_DURATION ;
duration_list_value : duration_value ( ( ',' duration_value )+ | SYM_LIST_CONTINUE ) ;
duration_interval_value :
      '|' '>'? duration_value SYM_INTERVAL_SEP '<'? duration_value '|'
    | '|' relop? duration_value '|'
    ;

term_code : QUALIFIED_TERM_CODE_REF ;
term_code_list_value : term_code ( ( ',' term_code )+ | SYM_LIST_CONTINUE ) ;

uri_value : URI ;

relop : '>' | '<' | '<=' | '>=' ;

//
//  ======================= Lexical rules ========================
//

SYM_LIST_CONTINUE: '...' ;
SYM_INTERVAL_SEP: '..' ;
