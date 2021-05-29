import 'package:flutter/material.dart';
import 'package:products/bloc/products_bloc.dart';

import 'package:products/bloc/provider.dart';
import 'package:products/models/product_model.dart';
import 'package:products/pages/product_page.dart';

class HomePage extends StatefulWidget {
  static final routeName = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProductsBloc? productsBloc;

  @override
  void dispose() {
    super.dispose();
    productsBloc!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    productsBloc = Provider.productsBloc(context);
    productsBloc!.loadProducts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: RefreshIndicator(
        child: _Body(_updateHome, productsBloc!),
        onRefresh: _updateHome,
      ),
      floatingActionButton: _AddProductButton(_updateHome),
    );
  }

  // Called when returning to the home page and when refreshing
  Future<void> _updateHome() async {
    await Future.delayed(Duration(milliseconds: 200));
    setState(() {});
  }
}

class _AddProductButton extends StatelessWidget {
  _AddProductButton(this.updateHome);

  final Function updateHome;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      // .then is called after popping off the route
      onPressed: () => Navigator.pushNamed(context, ProductPage.routeName)
          .then((value) => updateHome()),
    );
  }
}

class _Body extends StatelessWidget {
  _Body(this.updateHome, this.productsBloc);

  final Function updateHome;
  final ProductsBloc productsBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: productsBloc.productsStream,
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.hasData) {
          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, i) =>
                _Item(products[i], updateHome, productsBloc),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class _Item extends StatelessWidget {
  _Item(this.product, this.updateHome, this.productsBloc);

  final Product product;
  final Function updateHome;
  final ProductsBloc productsBloc;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction) => productsBloc.deleteProduct(product.id!),
      child: Card(
        child: Column(
          children: [
            (product.pictureUrl == null)
                ? Image.asset('assets/no-image.png')
                : FadeInImage(
                    placeholder: Image.asset('assets/jar-loading.gif').image,
                    image: NetworkImage(product.pictureUrl!),
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
            ListTile(
              title: Text('${product.title} - ${product.price}'),
              subtitle: Text('${product.id}'),
              onTap: () => Navigator.pushNamed(context, ProductPage.routeName,
                      arguments: product)
                  .then((value) => updateHome()),
            ),
          ],
        ),
      ),
    );
  }
}
