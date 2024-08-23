import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/logger/logger.dart';
import '../../../generated/graphql/query/country_details.graphql.dart';
import '../../../generated/graphql/schema.graphql.dart';

class CountryDetailsPage extends StatelessWidget {
  const CountryDetailsPage._({
    required this.countryId,
  });

  final String countryId;

  static const routeName = '/country_details';

  static Route<void> route({required String countryId}) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => CountryDetailsPage._(countryId: countryId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    const h4 = SizedBox(height: 4);

    final body = Query(
      options: QueryOptions(
        document: documentNodeQuerygetCountryDetails,
        variables: Variables$Query$getCountryDetails(
          first: 1,
          filter: Input$countrydetailsFilter(
            country_id: Input$BigIntFilter(eq: countryId),
          ),
        ).toJson(),
      ),
      builder: (QueryResult result, {fetchMore, refetch}) {
        if (result.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (result.hasException) {
          logger.warning(result.exception);
          return Center(child: Text(result.exception.toString()));
        }

        if (result.data == null) {
          return const Center(child: Text('データがありません'));
        }

        final countryDetailsData =
            Query$getCountryDetails.fromJson(result.data!);

        final countryDetails =
            countryDetailsData.countrydetailsCollection?.edges[0].node;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('首都: ${countryDetails?.capital}'),
                h4,
                Text('面積: ${countryDetails?.area} m2'),
                h4,
                Text('人口: ${countryDetails?.population} 人'),
                h4,
                Text('通貨: ${countryDetails?.currency}'),
                h4,
                Text('GDP: ${countryDetails?.gdp} 百万円'),
              ],
            ),
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'country details page',
          style: textTheme.titleLarge!.copyWith(
            color: colorScheme.onPrimary,
          ),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: DefaultTextStyle(style: textTheme.titleLarge!, child: body),
    );
  }
}
