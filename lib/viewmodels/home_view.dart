import 'package:flutter/material.dart';
import 'package:newone/ui/global.dart';
import 'package:newone/viewmodels/home_model.dart';
import 'package:provider/provider.dart';

class AnimatedCircle extends AnimatedWidget {
  final Tween<double> tween;
  final Tween<double> horizontalTween;
  final Animation<double> animation;
  final Animation<double> horizontalAnimation;
  final double flip;
  final Color color;

  // ignore: sort_constructors_first
  AnimatedCircle({
    Key key,
    @required this.tween,
    this.horizontalTween,
    @required this.animation,
    this.horizontalAnimation,
    @required this.flip,
    @required this.color
  }): assert(flip == 1 || flip== -1),
  super(key: key, listenable:animation);
  
  
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomeModel>(context);
    return Transform(
      alignment: FractionalOffset.centerLeft,
      transform: Matrix4.identity()
      ..scale(
        tween.evaluate(animation) * flip,
        tween.evaluate(animation),
      ),
      
      child: Transform(
        transform: Matrix4.identity()
        ..translate(horizontalTween != null
            ? horizontalTween.evaluate(horizontalAnimation)
            :0.0,
        ),
        child: Container(
          width: Global.radius,
          height: Global.radius,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              Global.radius/2.0 -
                  tween.evaluate(animation) / (Global.radius /2.0),
            )
          ),
          child: Icon(
            flip == 1 ? Icons.keyboard_arrow_right : Icons.keyboard_arrow_left,
            color: (model.index==0)?Global.mediumBlue :
            (model.index==1)?Global.white :
            (model.index==2)? Global.mediumYellow :
            Global.mediumRed,
          ),
        ),
      ),
    );
  }
}



class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin{
 AnimationController animationController;
 Animation startAnimation;
 Animation endAnimation;
 Animation horizontalAnimation;
 PageController pageController;
 @override
 void initState() {
   // TODO: implement initState
   super.initState();
   
   pageController =PageController();
   animationController =
       AnimationController(duration: Duration(milliseconds: 750), vsync: this);
  
   startAnimation = CurvedAnimation(
     parent: animationController,
     curve: Interval(0.000, 0.500, curve: Curves.easeInExpo),
   );
  
   endAnimation = CurvedAnimation(
     parent: animationController,
     curve: Interval(0.500, 1.000, curve: Curves.easeOutExpo),
   );
  
   horizontalAnimation = CurvedAnimation(
     parent: animationController,
     curve: Interval(0.750, 1.000,curve: Curves.easeInOutQuad),
   );
  
   animationController
     ..addStatusListener((status){
       final model = Provider.of<HomeModel>(context, listen: false);
       if(status== AnimationStatus.completed){
         model.swapColors();
         animationController.reset();
       }
     })
     ..addListener((){
     final  model= Provider.of<HomeModel>(context, listen: false);
     if(animationController.value > 0.5){
       model.isHalfWay = true;
     }else {
       model.isHalfWay = false;
     }
   });
 }

 @override
 void dispose() {
   animationController.dispose();
   // TODO: implement dispose
   super.dispose();
 }
 
  @override
  Widget build(BuildContext context) {
    final model= Provider.of<HomeModel>(context);
    final screenWidth= MediaQuery.of(context).size.width;
    final screenHeight= MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor:
      model.isHalfWay ? model.foreGroundColor : model.backGroundColor,
      body: Stack(
        children: <Widget>[
          Container(
            color:
            model.isHalfWay ? model.foreGroundColor : model.backGroundColor,
            width: screenWidth / 2.0 - Global.radius / 2.0,
            height: double.infinity,
          ),
        
          Transform(
            transform: Matrix4.identity()
              ..translate(
                screenWidth /2 - Global.radius /2.0,
                screenHeight - Global.radius - Global.bottomPadding,
              ),
          child: GestureDetector(
            onTap: (){
              if(animationController.status != AnimationStatus.forward ){
                model.isToggled = !model.isToggled;
                model.index++;
                if(model.index >3){
                  model.index=0;
                }
                pageController.animateToPage(model.index,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOutQuad);
                animationController.forward();
              }
              
            },
            child: Stack(
              children: <Widget>[
                AnimatedCircle(
                  animation: startAnimation,
                  flip: 1.0,
                  color:model.foreGroundColor,
                  tween: Tween<double> (begin:1.0, end:Global.radius),
                ),
               
                AnimatedCircle(
                  animation: endAnimation,
                  color:model.backGroundColor,
                  flip: -1.0,
                  horizontalTween:
                  Tween<double> (begin:0, end: -Global.radius),
                  horizontalAnimation: horizontalAnimation,
                  tween: Tween<double>(begin:Global.radius, end:1.0),

                ),
              ],
            ),
            
            
          ),),
          IgnorePointer(
            ignoring: true,
            child: PageView.builder(
              controller: pageController,
                itemCount: 4,
                itemBuilder: (context, index){
                return Center(
                  child: Text(
                    'Page ${index +1 }',
                    style: TextStyle(
                      color: (model.index==0)?Global.mediumBlue :
                      (model.index==1)?Global.white :
                      (model.index==2)? Global.mediumYellow :
                      Global.mediumRed,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                );
                }),
          )
        ],
      ),
    );
  }
  
}
