import { eq } from "drizzle-orm";
import type { BuyListRequest } from "./create-buyList";
import { buyList } from "../../db/schemas/buyList";
import { db } from "../../db";




export const updateBuyList = async (buyListRequest: BuyListRequest, id : string) => {
  const [buyListUpdated] = await db
    .update(buyList)
    .set({
      name: buyListRequest.name,
      status: buyListRequest.status,
      id_events: buyListRequest.id_events,
    })
    .where(eq(buyList.id, id))
    .returning();

  return buyListUpdated;
}