*&---------------------------------------------------------------------*
*& Report ZABAP_ALV_REP1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zabap_alv_rep1.

INCLUDE zabap_alv_rep1_top.
INCLUDE zabap_alv_rep1_scr100.
INCLUDE zabap_alv_rep1_f01.

SELECT-OPTIONS: so_otype FOR wbcrossgt-otype,
                so_name FOR wbcrossgt-name,
                so_incl FOR wbcrossgt-include.
PARAMETERS: p_rows TYPE i DEFAULT 10000.

INITIALIZATION.
  go_rep1 = NEW zcl_abap_alv_rep1( ).

START-OF-SELECTION.
  go_rep1->get_data( is_ss =
            VALUE zsabap_alv_rep1_selscr( so_otype = so_otype[]
                                          so_name = so_name[]
                                          so_incl = so_incl[]
                                          p_rows = p_rows ) ).
  CALL SCREEN 0100.
