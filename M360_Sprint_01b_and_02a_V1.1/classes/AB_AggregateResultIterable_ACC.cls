global class AB_AggregateResultIterable_ACC implements Iterable<AggregateResult> {
   global Iterator<AggregateResult> Iterator(){
      return new AB_AggregateResultIterator_ACC();
   }
}