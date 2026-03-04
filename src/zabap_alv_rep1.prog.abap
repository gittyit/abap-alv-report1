*&---------------------------------------------------------------------*
*& Report ZABAP_ALV_REP1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zabap_alv_rep1.

INCLUDE zabap_alv_rep1_top.
INCLUDE zabap_alv_rep1_scr100.
INCLUDE zabap_alv_rep1_f01.

SELECT-OPTIONS: so_otype FOR wbcrossgt-otype.
PARAMETERS: p_rows TYPE i DEFAULT 10000.

INITIALIZATION.
  lo_rep1 = NEW zcl_abap_alv_rep1( ).

START-OF-SELECTION.
  lo_rep1->get_data( is_ss =
            VALUE zsabap_alv_rep1_selscr( so_otype = so_otype[]
                                          p_rows = p_rows ) ).
  CALL SCREEN 0100.
