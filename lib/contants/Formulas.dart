
 getIdealWeight(String gender,String heightInCm){
  var height = int.parse(heightInCm);
  if(gender.toLowerCase() == "male"){
    return height - 100;
  }else{
    return height - 105;
  }
}


getIdealKcals(int idealWeight , String activityLevel){
  if(activityLevel.toLowerCase() == "mild"){
    return 20 *idealWeight;
  }else if(activityLevel.toLowerCase() == "moderate"){
    return 25 *idealWeight;
  }else{
    return 30*idealWeight;
  }
}