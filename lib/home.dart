import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodreceipe/model.dart';
import 'package:foodreceipe/recipeview.dart';
import 'package:http/http.dart';
import 'package:foodreceipe/search.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading=true;
  TextEditingController search = TextEditingController();
  List<ReceipeModel> receipelist = <ReceipeModel>[];
  List recipecatlist=[{"imgurl":"images/spicy.jpg","heading":"Spicy Food"},{"imgurl":"images/Deserts.jpg","heading":"Deserts"},{"imgurl":"images/Sweets.jpg","heading":"Sweets"},];

  getReceipe(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=b87725d9&app_key=cd3864f25fad4f4e2e9a54915beb8443";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    data['hits'].forEach((element) {
      ReceipeModel rmodel = ReceipeModel();
      rmodel = ReceipeModel.fromMap(element["recipe"]);
      receipelist.add(rmodel);

      setState(() {
        isLoading=false;
      });
    });
    receipelist.forEach((Receipe) {
      print(Receipe.applabel);
      print(Receipe.appcalories);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getReceipe("ladoo");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xff5da3e1),
              Color(0xff7b4fc0),
            ])),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                //search bar
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if ((search.text).replaceAll(" ", "") == " ") {
                              print("Blank search");
                            } else {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> Search(search.text)));
                            }
                          },
                          child: Container(
                            child: const Icon(Icons.search),
                            margin: const EdgeInsets.fromLTRB(2, 0, 7, 0),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: search,
                            decoration: const InputDecoration(
                              hintText: "Let's Cook Something !",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "What Do You Want To Cook Today?",
                          style: TextStyle(fontSize: 35, color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Let's Cook Something Special",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: isLoading ? CircularProgressIndicator():ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: receipelist.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>Recipeview(receipelist[index].appurl)));
                          },
                          child: Card(
                            margin: EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0.0,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    receipelist[index].appimgurl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.black26,
                                      ),
                                      child: Text(
                                        receipelist[index].applabel,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      )),
                                ),
                                Positioned(
                                    right: 0,
                                    width: 70,
                                    height: 40,
                                    child:
                                       Container(
                                           decoration: BoxDecoration(
                                             color: Colors.white,
                                             borderRadius: BorderRadius.only(
                                               topRight: Radius.circular(10),
                                               bottomLeft: Radius.circular(10),
                                             )
                                           ),
                                           child: Center(
                                             child: Row(
                                               mainAxisAlignment: MainAxisAlignment.center,
                                               children: [
                                                 Icon(Icons.local_fire_department_sharp,size: 20,),
                                                 Text(receipelist[index].appcalories.toString().substring(0,5),
                                                 style: TextStyle(fontSize: 14) ,),
                                               ],
                                             ),
                                           )))
                              ],
                            ),
                          ),
                        );
                      }),

                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0,left: 20.0),
                  child: Container(
                    child: Text("Explore Food Recipe Categories",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  ),
                ),
                Container(
                  height: 150,
                  child: ListView.builder(itemCount: recipecatlist.length, shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                    return Container(
                      child: InkWell(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Search(recipecatlist[index]["heading"])));
                        },
                        child: Card(
                          margin: EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0.0,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.asset(recipecatlist[index]["imgurl"]!,
                                  fit: BoxFit.cover,
                                  width: 200,
                                  height: 150,
                                ),
                              ),
                              Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  top: 0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.black26
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(recipecatlist[index]["heading"],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),),
                                      ],
                                    ),
                                  ),)
                            ],
                          ),
                        ),
                      ),
                    );
                  },),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
