// Load and merge all GraphQL schema files
import { loadFilesSync } from '@graphql-tools/load-files';
import { mergeTypeDefs } from '@graphql-tools/merge';
import { join } from 'path';

export async function loadSchema() {
  const typesArray = loadFilesSync(join(__dirname, '../schema/**/*.graphql'));
  return mergeTypeDefs(typesArray);
}

