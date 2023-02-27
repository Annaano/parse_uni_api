import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'university_cubit.dart';
import 'university_state.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../models/list_data_model.dart';

class UniversityListFromAPI extends StatefulWidget {
  final List<ListDataModel> dataList;
  final String countryName;
  const UniversityListFromAPI(
      {Key? key, required this.countryName, required this.dataList})
      : super(key: key);

  @override
  State<UniversityListFromAPI> createState() => _UniversityListFromAPIState();
}

class _UniversityListFromAPIState extends State<UniversityListFromAPI> {
  @override
  void initState() {
    context.read<ApiCubit>().fetchUniversities(widget.countryName);
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Internet Connection'),
          content:
              const Text('Turn on celluar data or use Wi-Fi to access data.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'UNIVERSITIES OF ${widget.countryName.toUpperCase()}',
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
      ),
      body: BlocBuilder<ApiCubit, ApiState>(builder: (context, state) {
        if (state.internetConnection == false && !state.isLoading) {
          return const SizedBox();
        } else if (state.universities.isEmpty || state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
            itemCount: state.universities.length,
            itemBuilder: (context, index) {
              return getUniversitiesListPage(state.universities[index]);
            });
      }),
    );
  }

  Widget getUniversitiesListPage(index) {
    var uniName = index['name'];
    var uniCountry = index['country'];
    var webPage = index['web_pages'][0];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(uniName.toString(),
                  style: const TextStyle(fontSize: 17),
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: (Text(uniCountry.toString(),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.left)),
              ),
              TextButton(
                onPressed: () async {
                  var url = webPage;
                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text(
                  'READ MORE ',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
