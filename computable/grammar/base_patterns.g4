//
//  General purpose patterns used in all openEHR parser and lexer tools
//

grammar base_patterns;

//
//  ============== Parse rules ==============
//

type_id : TYPE_NAME ( '<' type_id ( ',' type_id )* '>' )? ;

//
//  ============== Lexical rules ==============
//

// ---------- whitespace & comments ----------

WS : 
      [ \t\r]+      // skip
    | '\n'+         // increment line count
    | '--'.*        // Ignore comments
    | '--'.*'\n'    // (increment line count)
    ;

// ---------- ISO8601 Date/Time values ----------

ISO8601_DATE      :     YEAR '-' MONTH ( '-' DAY )? ;
ISO8601_TIME      :     HOUR ':' MINUTE ( ':' SECOND ( ',' INTEGER )?)? ( TIMEZONE )? ; 
ISO8601_DATE_TIME :     YEAR '-' MONTH '-' DAY 'T' HOUR (':' MINUTE (':' SECOND ( ',' [0-9]+ )?)?)? ( TIMEZONE )? ;

fragment TIMEZONE   :     'Z' | ('+'|'-') HOUR_MIN ;   // hour offset, e.g. `+0930`, or else literal `Z` indicating +0000.
fragment MONTH      :     ( [0][0-9] | [1][0-2] ) ;    // month in year
fragment DAY        :     ( [012][0-9] | [3][0-2] ) ;  // day in month
fragment HOUR       :     ( [01]?[0-9] | [2][0-3] ) ;  // hour in 24 hour clock
fragment MINUTE     :     [0-5][0-9] ;                 // minutes
fragment SECOND     :     [0-5][0-9] ;                 // seconds

// ISO8601 DURATION PnYnMnWnDTnnHnnMnn.nnnS 
// here we allow a deviation from the standard to allow weeks to be
// mixed in with the rest since this commonly occurs in medicine
ISO8601_DURATION : 'P'(DIGIT+[yY])?(DIGIT+[mM])?(DIGIT+[wW])?(DIGIT+[dD])?('T'(DIGIT+[hH])?(DIGIT+[mM])?(DIGIT+('.'DIGIT+)?[sS])?)? ;

// -------- other values --------

ARCHETYPE_ID  : (DOMAIN_NAME '::')? IDENTIFIER '-' IDENTIFIER '-' IDENTIFIER '.' NAME '.v' VERSION_ID ;

DOMAIN_NAME   : NAME ('.' NAME)+ ;
IDENTIFIER    : ALPHA_CHAR ID_CHAR* ;
TYPE_NAME     : ALPHA_UPPER ID_CHAR* ;
ATTRIBUTE_ID  : '_'? ALPHA_LOWER ID_CHAR* ;
NAME          : ALPHA_CHAR NAME_CHAR+ ;
VALUE         : ( NAME_CHAR | ^[ \r\n\t] )* ;

DOTTED_NUMERIC: DIGIT+ DOT_SEGMENT+ ;
VERSION_ID    : DIGIT+ ( DOT_SEGMENT ( DOT_SEGMENT ( ('-rc'|'-alpha') DOT_SEGMENT? )? )? )? ;
fragment DOT_SEGMENT : '.' DIGIT+ ;

// -------- primitive types --------

URI : [a-z]+ ':' ( '//' | '/' | ~[/ ]+ )? ~[ \t\n]+? ; // just a simple recogniser, the full thing isn't required
QUALIFIED_TERM_CODE_REF : '[' NAMECHAR_PAREN+ '::' NAME_CHAR+ ']' ;  // e.g. [ICD10AM(1998)::F23]

INTEGER :   DIGIT+ E_SUFFIX? ;
REAL :      DIGIT+'.'DIGIT+ E_SUFFIX? ;
fragment E_SUFFIX : [eE][+-]?DIGIT+ ;

STRING : '"' STRING_CHAR*? '"' ;
fragment STRING_CHAR : UTF8CHAR | '\\'['nrt\"] | ~["] ;

CHARACTER : '\'' CHAR '\'' ;
fragment CHAR : UTF8CHAR | '\\['nrt\]' | ~[\n'] ;

SYM_TRUE : [Tt][Rr][Uu][Ee] ;
SYM_FALSE : [Ff][Aa][Ll][Ss][Ee] ;

// -------- character fragments --------

fragment ALPHA_CHAR    : [a-zA-Z] ;
fragment ALPHA_UPPER   : [A-Z] ;
fragment ALPHA_LOWER   : [a-z] ;
fragment DIGIT         : [0-9] ;
fragment ALPHANUM_CHAR : ALPHA_CHAR | DIGIT ;
fragment ID_CHAR       : ALPHANUM_CHAR | '_' ;
fragment NAME_CHAR     : ID_CHAR | '-' ;
fragment NAME_CHAR_PAREN: NAME_CHAR | [()] ;

fragment UTF8CHAR : 
    | '\u00C0'..'\u00D6'
    | '\u00D8'..'\u00F6'
    | '\u00F8'..'\u02FF'
    | '\u0300'..'\u036F'
    | '\u0370'..'\u037D'
    | '\u037F'..'\u1FFF'
    | '\u200C'..'\u200D'
    | '\u203F'..'\u2040'
    | '\u2070'..'\u218F'
    | '\u2C00'..'\u2FEF'
    | '\u3001'..'\uD7FF'
    | '\uF900'..'\uFDCF'
    | '\uFDF0'..'\uFFFD'
    ;

