CLASS lhc_ZRO_R_PRODUCTS DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zro_r_products RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zro_r_products RESULT result.
    METHODS validateproduct FOR VALIDATE ON SAVE
      IMPORTING keys FOR zro_r_products~validateproduct.


ENDCLASS.

CLASS lhc_ZRO_R_PRODUCTS IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.



  METHOD validateProduct.

    READ ENTITIES OF zro_r_products IN LOCAL MODE
      ENTITY zro_r_products
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_products).

    LOOP AT lt_products INTO DATA(ls_product).

      " 1️⃣ Name mandatory
      IF ls_product-Name IS INITIAL.
        APPEND VALUE #(
          %tky = ls_product-%tky
        ) TO failed-zro_r_products.

        APPEND VALUE #(
          %tky = ls_product-%tky
          %msg = new_message(
                   id       = '00'
                   number   = '001'
                   severity = if_abap_behv_message=>severity-error
                   v1       = 'Name is mandatory'
                 )
        ) TO reported-zro_r_products.
      ENDIF.

      " 2️⃣ Price must be > 0
      IF ls_product-Price <= 0.
        APPEND VALUE #(
          %tky = ls_product-%tky
        ) TO failed-zro_r_products.

        APPEND VALUE #(
          %tky = ls_product-%tky
          %msg = new_message(
                   id       = '00'
                   number   = '001'
                   severity = if_abap_behv_message=>severity-error
                   v1       = 'Price must be greater than 0'
                 )
        ) TO reported-zro_r_products.
      ENDIF.

      " 3️⃣ Rating must be 1–5
      IF ls_product-Rating < 1 OR ls_product-Rating > 5.
        APPEND VALUE #(
          %tky = ls_product-%tky
        ) TO failed-zro_r_products.

        APPEND VALUE #(
          %tky = ls_product-%tky
          %msg = new_message(
                   id       = '00'
                   number   = '001'
                   severity = if_abap_behv_message=>severity-error
                   v1       = 'Rating must be between 1 and 5'
                 )
        ) TO reported-zro_r_products.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.






ENDCLASS.