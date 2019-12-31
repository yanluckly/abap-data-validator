CLASS zcl_adv_regex_check DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zif_adv_check.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_adv_regex_check IMPLEMENTATION.

  METHOD zif_adv_check~check.

    DATA: regex TYPE REF TO cl_abap_regex.

    valid = abap_false.

    DATA(string_regex) = CONV string( data ).

    TRY.
        regex = NEW #( pattern  = string_regex ).
      CATCH cx_sy_invalid_regex.
        RETURN.
    ENDTRY.

    valid = abap_true.

  ENDMETHOD.

ENDCLASS.
