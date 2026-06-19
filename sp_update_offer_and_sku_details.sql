CREATE OR REPLACE PROCEDURE sp_update_offer_and_sku_details()
LANGUAGE plpgsql
AS $$
BEGIN

    -- Step 1: Deactivate individual SKU detail rows where the product is inactive
    UPDATE "tEventOfferDetail" eod
    SET "isSkuActive" = FALSE
    FROM "tEvent" ev,
         "tProducts" p
    WHERE ev."eventId" = eod."eventId"
      AND p."sku" = eod."sku"
      AND p."isActive" = FALSE
      AND ev."status" <> 'Completed';

    -- Step 2: Deactivate offers when at least one OfferNumber has no active SKUs
    UPDATE "tEventOffer" eo
    SET "pagePosition" = 0,
        "isOfferActive" = FALSE
    FROM "tEvent" ev
    WHERE ev."eventId" = eo."eventId"
      AND ev."status" <> 'Completed'
      AND EXISTS (
            SELECT 1
            FROM "tEventOfferDetail" eod
            WHERE eod."offerId" = eo."offerId"
            GROUP BY eod."offerId", eod."offerNumber"
            HAVING COUNT(*) FILTER (
                       WHERE eod."isSkuActive" = TRUE
                   ) = 0
      );

    -- Step 3: Reset search history for deactivated offers
    UPDATE "tEventOfferSearchHistory" esh
    SET "positionId" = 0
    FROM "tEventOffer" eo,
         "tEvent" ev
    WHERE esh."eventOfferId" = eo."offerId"
      AND ev."eventId" = eo."eventId"
      AND ev."status" <> 'Completed'
      AND eo."isOfferActive" = FALSE;

    -- Step 4: Clear mudmap entries for deactivated offers
    UPDATE "tMudMapDetail" mmd
    SET
        "eventOfferId"     = NULL,
        "offerName"        = NULL,
        "offerType"        = NULL,
        "everydayPrice"    = NULL,
        "isReserved"       = FALSE,
        "advertisedPrice"  = NULL,
        "saveValue"        = NULL,
        "savePercent"      = NULL,
        "message"          = NULL,
        "partNumber"       = NULL,
        "clearance"        = NULL,
        "multiBuy"         = NULL,
        "combo"            = NULL,
        "new"              = NULL,
        "loyality"         = NULL,
        "isActive"         = FALSE,
        "userName"         = NULL,
        "requiredQuantity" = NULL,
        "fromPrice"        = NULL,
        "purchaseQuantity" = NULL,
        "freeQuantity"     = NULL,
        "lockedAt"         = NULL,
        "offerTypeId"      = NULL
    FROM "tEventOffer" eo,
         "tEvent" ev
    WHERE mmd."eventOfferId" = eo."offerId"
      AND ev."eventId" = eo."eventId"
      AND ev."status" <> 'Completed'
      AND eo."isOfferActive" = FALSE;

    -- Step 5: Reset page position on offer details for deactivated offers
    UPDATE "tEventOfferDetail" eod
    SET "pagePosition" = 0
    FROM "tEventOffer" eo,
         "tEvent" ev
    WHERE eod."eventOfferId" = eo."offerId"
      AND ev."eventId" = eo."eventId"
      AND ev."status" <> 'Completed'
      AND eo."isOfferActive" = FALSE;

END;
$$;