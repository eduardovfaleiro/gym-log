int getNewOrder(List list) {
  return list.fold(-1, (max, e) => e["order"]! > max ? e["order"]! : max) + 1;
}
