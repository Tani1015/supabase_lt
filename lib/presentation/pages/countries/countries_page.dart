// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../common/logger/logger.dart';
import '../../../generated/graphql/query/countries.graphql.dart';
import '../../../generated/graphql/schema.graphql.dart';
import '../country_details/country_details_page.dart';

class CountriesPage extends HookWidget {
  const CountriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final body = Query$getCountries$Widget(
      options: Options$Query$getCountries(
        variables: Variables$Query$getCountries(first: 20),
      ),
      builder: (QueryResult result, {fetchMore, refetch}) {
        if (result.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (result.hasException) {
          logger.warning(result.exception);
          return Center(child: Text(result.exception.toString()));
        }

        if (result.data == null) {
          return const Center(child: Text('データがありません'));
        }

        final countriesData = Query$getCountries.fromJson(result.data!);
        final countries = List<Query$getCountries$countriesCollection$edges>.of(
          countriesData.countriesCollection?.edges ?? [],
        );

        // ページング処理のための変数
        final hasNextPage =
            countriesData.countriesCollection?.pageInfo.hasNextPage ?? false;
        final endCursor = countriesData.countriesCollection?.pageInfo.endCursor;

        return ListView.builder(
          itemCount: countries.length,
          itemBuilder: (context, index) {
            final country = countries[index].node;
            final population =
                country.countrydetailsCollection?.edges[0].node.population;
            return ListTile(
              onTap: () {
                Navigator.of(context).push<void>(
                  CountryDetailsPage.route(countryId: country.id),
                );
              },
              title: Text(country.name),
              subtitle: Text('人口: $population'),
            );
          },
        );
      },
    );

    final updateIcon = Mutation$updateCountries$Widget(
      options: WidgetOptions$Mutation$updateCountries(
        update: (GraphQLDataProxy cache, QueryResult? result) {
          if (result?.data != null) {
            logger.info('update Result: ${result!.data}');
            cache.writeQuery(
              const Request(
                operation: Operation(
                  document: documentNodeQuerygetCountries,
                ),
              ),
              data: result.data!,
            );
          }
        },
      ),
      builder: (runMutation, mutationResult) {
        return IconButton(
          onPressed: () {
            runMutation(
              Variables$Mutation$updateCountries(
                update: Input$countriesUpdateInput(name: 'Canada'),
              ),
            );
            logger.warning(mutationResult!.data);
          },
          icon: Icon(
            Icons.update,
            color: colorScheme.onPrimary,
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        title: Text(
          'GraphQL',
          style: textTheme.titleLarge!.copyWith(
            color: colorScheme.onPrimary,
          ),
        ),
        leading: updateIcon,
      ),
      body: body,
    );
  }
}
