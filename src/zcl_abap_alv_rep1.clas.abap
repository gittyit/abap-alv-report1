class ZCL_ABAP_ALV_REP1 definition
  public
  final
  create public .

public section.

  methods GET_DATA
    importing
      !IS_SS type ZSABAP_ALV_REP1_SELSCR optional .
  methods DISPLAY_DATA
    importing
      !IV_CPROG type SY-CPROG default SY-CPROG .
  methods PAI_0100
    importing
      !IV_UCOMM type SY-UCOMM default SY-UCOMM .
protected section.
private section.

  data MT_DATA1 type ZTABAP_ALV_REP1_DATA .
  data MO_GRID1 type ref to CL_GUI_ALV_GRID .
  data MO_CONT1 type ref to CL_GUI_CUSTOM_CONTAINER .
ENDCLASS.



CLASS ZCL_ABAP_ALV_REP1 IMPLEMENTATION.


  METHOD display_data.

    SET PF-STATUS 'STAT_0100' OF PROGRAM iv_cprog.
    SET TITLEBAR 'TIT1' OF PROGRAM iv_cprog.

    IF mo_cont1 IS NOT BOUND OR mo_grid1 IS NOT BOUND.

      mo_cont1 = NEW cl_gui_custom_container( container_name = 'CONT1' ).
      mo_grid1 = NEW cl_gui_alv_grid( i_parent = mo_cont1 ).

    ENDIF.

    mo_grid1->set_table_for_first_display(
        EXPORTING
          i_structure_name = 'ZSABAP_ALV_REP1_DATA'
        CHANGING
          it_outtab = mt_data1 ).

  ENDMETHOD.


  METHOD get_data.

    REFRESH: mt_data1.
    SELECT * FROM wbcrossgt as wt
      JOIN e071 as e1
      ON e1~obj_name = wt~name
      INTO CORRESPONDING FIELDS OF TABLE @mt_data1
      UP TO @is_ss-p_rows ROWS
      WHERE otype IN @is_ss-so_otype.

  ENDMETHOD.


  METHOD pai_0100.

    CASE iv_ucomm.
      WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
        LEAVE TO SCREEN 0.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
