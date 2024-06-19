class ReceipeModel{
  late String applabel;
  late String appimgurl;
  late double appcalories;
  late String appurl;

  ReceipeModel({this.applabel="Ladoo",this.appimgurl="image",this.appcalories=0.000,this.appurl="url"});
  factory ReceipeModel.fromMap(Map receipe){
    return ReceipeModel(
      applabel: receipe["label"],
      appcalories: receipe["calories"],
      appimgurl: receipe["image"],
      appurl: receipe["url"],
    );
  }
}