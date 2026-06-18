ALTER TABLE "tPriceProductRules" 
ADD COLUMN "isActive" BOOLEAN DEFAULT TRUE;

ALTER TABLE "tProducts" 
ADD COLUMN "isActive" BOOLEAN DEFAULT TRUE;

ALTER TABLE "tPriceList" 
ADD COLUMN "isActive" BOOLEAN DEFAULT TRUE;

ALTER TABLE "tPriceListDetail" 
ADD COLUMN "isActive" BOOLEAN DEFAULT TRUE;

ALTER TABLE "tEventOffer" 
ADD COLUMN "isOfferActive" BOOLEAN DEFAULT TRUE;

ALTER TABLE "tEventOfferDetail" 
ADD COLUMN "isSkuActive" BOOLEAN DEFAULT TRUE;

UPDATE "tPriceProductRules"
SET "isActive" = TRUE;

UPDATE "tProducts"
SET "isActive" = TRUE;

UPDATE "tPriceList"
SET "isActive" = TRUE;

UPDATE "tPriceListDetail"
SET "isActive" = TRUE;

UPDATE "tEventOffer"
SET "isOfferActive" = TRUE;

UPDATE "tEventOfferDetail"
SET "isSkuActive" = TRUE;

