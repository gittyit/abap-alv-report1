class ZCL_ABAP_ALV_REP1 definition
  public
  final
  create public .

public section.

  methods GET_DATA
    importing
      !IS_SS type ZSABAP_ALV_REP1_SELSCR optional .
  methods PBO_0100
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

  methods GET_FCAT
    importing
      !IV_STRUCTURE type DD02L-TABNAME
    returning
      value(RT_FCAT) type LVC_T_FCAT .
ENDCLASS.



CLASS ZCL_ABAP_ALV_REP1 IMPLEMENTATION.


  METHOD get_data.

    DATA: lt_adds TYPE RANGE OF e071-trkorr.

* Exclude add-ons from requests
    IF is_ss-p_noadds = 'X'.
      lt_adds = VALUE #( ( sign = 'E'
                           option = 'CP'
                           low = 'SAPK*' ) ).
    ENDIF.


    CLEAR: mt_data1.
    SELECT wt~otype, wt~name, wt~include, e1~trkorr, e1~as4pos,
           e1~pgmid, e1~object, e1~obj_name
           FROM wbcrossgt AS wt
      JOIN e071 AS e1
      ON e1~obj_name = wt~name
      INTO TABLE @mt_data1
      UP TO @is_ss-p_rows ROWS
      WHERE wt~otype IN @is_ss-so_otype AND
            wt~name IN @is_ss-so_name AND
            wt~include IN @is_ss-so_incl AND
            e1~trkorr IN @lt_adds.

  ENDMETHOD.


  METHOD pai_0100.

    CASE iv_ucomm.
      WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
        LEAVE TO SCREEN 0.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.


  METHOD get_fcat.

    DATA: lt_fcat    TYPE lvc_t_fcat,
          lt_fields  TYPE ddfields,
          lo_structd TYPE REF TO cl_abap_tabledescr.

    CHECK iv_structure IS NOT INITIAL.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
*       I_BUFFER_ACTIVE        =
        i_structure_name       = iv_structure
*       I_CLIENT_NEVER_DISPLAY = 'X'
*       I_BYPASSING_BUFFER     =
*       i_internal_tabname     =
      CHANGING
        ct_fieldcat            = lt_fcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
    ENDIF.

    LOOP AT lt_fcat ASSIGNING FIELD-SYMBOL(<fs_fs>).
      <fs_fs>-col_opt = 'X'.
      CASE <fs_fs>-fieldname.
        WHEN 'OTYPE' OR 'NAME' OR 'INCLUDE'.
          <fs_fs>-key = 'X'.
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.

    RETURN lt_fcat.

  ENDMETHOD.


  METHOD pbo_0100.

    SET PF-STATUS 'STAT_0100' OF PROGRAM iv_cprog.
    SET TITLEBAR 'TIT1' OF PROGRAM iv_cprog.

    IF mo_cont1 IS NOT BOUND OR mo_grid1 IS NOT BOUND.

      mo_cont1 = NEW cl_gui_custom_container( container_name = 'CONT1' ).
      mo_grid1 = NEW cl_gui_alv_grid( i_parent = mo_cont1 ).

      DATA(lt_fc) = get_fcat( iv_structure = 'ZSABAP_ALV_REP1_DATA' ).

      mo_grid1->set_table_for_first_display(
        EXPORTING
          i_bypassing_buffer = abap_true
          i_structure_name = 'ZSABAP_ALV_REP1_DATA'
          is_layout = VALUE #( zebra = 'X'
                               col_opt = 'X' )
        CHANGING
          it_fieldcatalog = lt_fc
          it_outtab = mt_data1 ).

    ELSE.

      mo_grid1->refresh_table_display( is_stable = CONV lvc_s_stbl('XX') ).

    ENDIF.



  ENDMETHOD.
ENDCLASS.
