global class AB_AggregateResultIterable implements Iterable<AggregateResult> {
   global Iterator<AggregateResult> Iterator(){
      return new AB_AggregateResultIterator_Routes();
   }
}