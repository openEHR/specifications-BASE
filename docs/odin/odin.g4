//
//	description: Antlr4 grammar for Object Data Instance Notation (ODIN)
//	author:      Thomas Beale <thomas.beale@openehr.org>
//	support:     openEHR Specifications PR tracker <https://openehr.atlassian.net/projects/SPECPR/issues>
//	copyright:   Copyright (c) 2015 openEHR Foundation
//	license:     Apache 2.0 License <http://www.apache.org/licenses/LICENSE-2.0.html>
//

grammar odin;
import odin_values;

//
// -------------------------- Parse Rules --------------------------
//

odin_text :
      attr_vals 
    | complex_object_block 
	;

attr_vals : attr_val ';'? ( attr_val ';'? )* ;

attr_val : V_ATTRIBUTE_ID '=' object_block ;

object_block : 
      ( '(' type_id ')' )? ( complex_object_block | primitive_object_block )
    | object_reference_block 
    ;

complex_object_block : 
      single_attr_object_block 
    | container_attr_object_block 
    ;

single_attr_object_block : '<' attr_vals? '>' ;

container_attr_object_block : '<' keyed_object* '>' ;

keyed_object : object_key '=' object_block ;

object_key : '[' primitive_value ']' ;	// probably should limit to String and Integer

// ------ leaf types ------

primitive_object_block : '<' primitive_object '>' ;

primitive_object :
      primitive_value 
    | primitive_list_value 
    | primitive_interval_value 
    | term_code 
    | term_code_list_value 
    ;

primitive_value :
      string_value 
    | integer_value 
    | real_value 
    | boolean_value 
    | character_value 
    | date_value 
    | time_value 
    | date_time_value 
    | duration_value 
    | uri_value 
    ;

primitive_list_value : 
      string_list_value 
    | integer_list_value 
    | real_list_value 
    | boolean_list_value 
    | character_list_value 
    | date_list_value 
    | time_list_value 
    | date_time_list_value 
    | duration_list_value 
    ;

primitive_interval_value :
      integer_interval_value
    | real_interval_value
    | date_interval_value
    | time_interval_value
    | date_time_interval_value
    | duration_interval_value
    ;

object_reference_block : '<' ( absolute_path | absolute_path_list ) '>' ;

absolute_path_list  : absolute_path ( ( ',' absolute_path )+ | '...' ) ;

absolute_path       : '/' ( relative_path )? ;
relative_path       : path_segment ( '/' path_segment )+ ;
path_segment        : V_ATTRIBUTE_ID ( '[' ( V_STRING | V_INTEGER ) ']' )? ; 

//
// -------------------------- Lexical entities --------------------------
//

// ---------- embedded syntax blocks --------------

CADL_BLOCK : '{' ( CADL_BLOCK | ~[{}]*? ) '}' ;
 
