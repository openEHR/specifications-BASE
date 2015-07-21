//
// grammar defining ODIN terminal value types, including atoms, lists and intervals
//

parser grammar odin_values;

string_value : V_STRING ;
string_list_value : string_value ( ( ',' string_value )+ | '...' ) ;

integer_value : ( '+' | '-' )? V_INTEGER ;
integer_list_value : integer_value ( ( ',' integer_value )+ | '...' ) ;
integer_interval_value :
      '|' '>'? integer_value '..' '<'? integer_value '|'
    | '|' RELOP? integer_value '|'
    ;

real_value : ( '+' | '-' )? V_REAL ;
real_list_value : real_value ( ( ',' real_value )+ | '...' ) ;
real_interval_value :
      '|' '>'? real_value '..' '<'? real_value '|'
    | '|' RELOP? real_value '|'
    ;

boolean_value : SYM_TRUE | SYM_FALSE ;
boolean_list_value : boolean_value ( ( ',' boolean_value )+ | '...' ) ;

character_value : V_CHARACTER ;
character_list_value : character_value ( ( ',' character_value )+ | '...' ) ;

date_value : V_ISO8601_DATE ;
date_list_value : date_value ( ( ',' date_value )+ | '...' ) ;
date_interval_value :
      '|' '>'? date_value '..' '<'? date_value '|'
    | '|' relop? date_value '|'
    ;

time_value : V_ISO8601_TIME ;
time_list_value : time_value ( ( ',' time_value )+ | '...' ) ;
time_interval_value :
      '|' '>'? time_value '..' '<'? time_value '|'
    | '|' relop? time_value '|'
    ;

date_time_value : V_ISO8601_DATE_TIME ;
date_time_list_value : date_time_value ( ( ',' date_time_value )+ | '...' ) ;
date_time_interval_value :
      '|' '>'? date_time_value '..' '<'? date_time_value '|'
    | '|' relop? date_time_value '|'
    ;

duration_value : V_ISO8601_DURATION ;
duration_list_value : duration_value ( ( ',' duration_value )+ | '...' ) ;
duration_interval_value :
      '|' '>'? duration_value '..' '<'? duration_value '|'
    | '|' relop? duration_value '|'
    ;

term_code : V_QUALIFIED_TERM_CODE_REF ;
term_code_list_value : term_code ( ( ',' term_code )+ | '...' ) ;

uri_value : V_URI ;

relop : '>' | '<' | '<=' | '>=' ;

