import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:kwexpress/app/home/restaurant_detail/restaurant_detail_bloc.dart';
import 'package:kwexpress/app/models/food.dart';
import 'package:kwexpress/common_widgets/progress_dialog.dart';
import 'package:kwexpress/constants/app_colors.dart';
import 'package:kwexpress/constants/constants.dart';
import 'package:tuple/tuple.dart';

class OrderScreen extends StatefulWidget {
  final List<Food> cartFoodList;
  final RestaurantDetailBloc bloc;

  const OrderScreen({
    Key key,
    @required this.cartFoodList,
    @required this.bloc,
  }) : super(key: key);
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  TextStyle style1 = TextStyle(fontSize: 16);
  TextStyle style2 = TextStyle(fontSize: 14, color: Colors.grey);
  List<Food> cartFoodList;
  List<Tuple2<Food, int>> sortedOrder;
  int foodPrice;
  int fullOrderPrice;
  ProgressDialog pr;

  @override
  void initState() {
    cartFoodList = List();
    cartFoodList.addAll(widget.cartFoodList);
    sortedOrder = widget.bloc.getSortedOrder(widget.cartFoodList);
    foodPrice = widget.bloc.calculateFoodPrice(widget.cartFoodList);
    fullOrderPrice = foodPrice + Constants.deliveryPrice;
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    pr.style(
      message: 'Chargement',
      messageTextStyle: TextStyle(fontSize: 12),
      progressWidget: Container(
        child: CircularProgressIndicator(),
      ),
    );
    super.initState();
  }

  void removeFood(Food foodToRemove) {
    List<Food> temp = List();
    bool isFound = false;
    for (Food food in cartFoodList) {
      if (foodToRemove.name == food.name && !isFound)
        isFound = true;
      else
        temp.add(food);
    }

    cartFoodList.clear();
    cartFoodList.addAll(temp);
    sortedOrder = widget.bloc.getSortedOrder(cartFoodList);
    foodPrice = widget.bloc.calculateFoodPrice(cartFoodList);
    fullOrderPrice = foodPrice + Constants.deliveryPrice;
    setState(() {});
  }

  Widget buildReceipt() {
    return Column(
      children: [
        Divider(
          height: 10,
          color: Colors.grey,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sous-Total:',
                    style: style1,
                  ),
                  Text(
                    '$foodPrice DA',
                    style: style1,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Frais de livraison', style: style2),
                  Text(
                    'A partir de ${Constants.deliveryPrice} DA',
                    style: style2,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'total',
                    style: style1,
                  ),
                  Text(
                    '$fullOrderPrice DA',
                    style: style1,
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          height: 10,
          color: Colors.grey,
        ),
      ],
    );
  }

  void sendMessage() async {
    await pr.show();
    try {
      String message =
          await widget.bloc.createMessage(sortedOrder, fullOrderPrice);
      List<String> recipents = [Constants.phoneNumer1, Constants.phoneNumber2];
      await pr.hide();

      String _result = await sendSMS(message: message, recipients: recipents)
          .catchError((onError) {});
    } on Exception catch (e) {
      await pr.hide();
      String text =
          "L'application K&W Express a besoin de cette permission pour son bon fonctionnement";
      if (e is PlatformException) text = e.message;
      showError('Erreur', text);
    }
  }

  Future<void> showError(String title, String message) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              FlatButton(
                child: Text('Activer'),
                onPressed: () async {
                  try {
                    await widget.bloc
                        .createMessage(sortedOrder, fullOrderPrice);
                  } catch (e) {
                    print(e);
                  }
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget buildButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ButtonTheme(
        height: 50,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(color: AppColors.colorPrimary),
          ),
          onPressed: () => sendMessage(),
          color: AppColors.colorPrimary,
          textColor: Colors.white,
          child: Text(
            "Commander".toUpperCase(),
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget buildList() {
    return ListView.builder(
      itemCount: sortedOrder.length,
      itemBuilder: (context, index) {
        Food food = sortedOrder[index].item1;
        int repetition = sortedOrder[index].item2;
        return Card(
          elevation: 3,
          child: ListTile(
            title: Text(
              repetition.toString() + ' * ${food.header?.name} - ${food?.name}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              food.price + ' DA',
              style: TextStyle(
                  fontWeight: FontWeight.w900, color: AppColors.colorPrimary),
            ),
            trailing: SizedBox(
              width: 100,
              height: 50,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: AppColors.colorPrimary)),
                onPressed: () => removeFood(food),
                color: AppColors.colorPrimary,
                textColor: Colors.white,
                child: AutoSizeText(
                  "supprimer".toUpperCase(),
                  style: TextStyle(fontSize: 10),
                  maxLines: 1,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context, rootNavigator: true).pop(cartFoodList);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Panier'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(child: buildList()),
            buildReceipt(),
            buildButton(),
          ],
        ),
      ),
    );
  }
}
