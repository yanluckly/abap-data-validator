# abap-data-validation
A data validation tool.

ABAP Data validation is a tool to simplify data validation for SAP ABAP development.

Goals:
* General input/output.
* Customizable validation rules.
* Extendable validation program.

## Input / Output
Class ZCL_ADATA_VALIDATION provide a general validation method: VALIDATE. 

    TRY.
        DATA(result) = NEW zcl_adata_validation( )->validate(
             rules   = my_rules
             data    = uploaded_data
         ).
      CATCH zcx_adv_exception INTO DATA(ex).
        DATA(msg) = ex->get_text( ).
    ENDTRY.    

## Rules customization
By the parameter RULES, you can customize the validation.

    DATA: rules TYPE zcl_adata_validation=>ty_rules_t.

    rules = VALUE #(
      ( fname = 'FIELD1' required = abap_true  initial_or_empty = abap_false  user_type = zcl_adata_validation=>c_type_date )
      ( fname = 'FIELD2' required = abap_false initial_or_empty = abap_true   user_type = zcl_adata_validation=>c_type_date )
      ( fname = 'FIELD3' required = abap_true  initial_or_empty = abap_false  user_type = zcl_adata_validation=>c_type_email )
    ).

## Extend validation for special type
There are two ways to extend the validation:
* Pass regular expression by RULES-REGEX.
* Create a new class which implements the interface ZIF_ADV_CHECK, and add the type name & class name in ZCL_ADATA_VALIDATION->CONSTRUCTOR.

Regex example:

    DATA: rules TYPE zcl_adata_validation=>ty_rules_t.

    DATA: cases TYPE ty_case_t.

    cases = VALUE #(
        ( field3 = 'ZZZ2@gmail.com') "correct
        ( field3 = 'ZZ.Z2@gmail.com.cn') "incorrect
    ).

    rules = VALUE #(
      ( fname = 'FIELD3' user_type = zcl_adata_validation=>c_type_email regex = 'gmail\.com$' regex_msg = 'Only gmail supported')
    ).
    
Or add a new class: 

    METHOD constructor.

      check_config = VALUE #(
        ( type = zcl_adata_validation=>c_type_new  class = 'ZCL_ADV_NEWTYPE_CHECK'  message = 'Invalid value for field &.  ')
      ).

    ENDMETHOD.
    
## Configuration 
The configuration is hard code in class ZCL_ADATA_VALIDATION method CONSTRUCTOR, but you can redefine the CONSTRUCTOR to retrieve configuration from database tables or other source. It allows you to change the function without modify existed program.

## Exception
The exception class ZCX_ADV_EXCEPTION is copied from ZCX_ABAPGIT_EXCEPTION for it is easy to use:)

## TODO
Now only date, time and email type are supported. Need to add more check classes.