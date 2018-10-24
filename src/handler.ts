import 'source-map-support/register';
import { Context, HttpRequest } from 'azure-functions-ts-essentials';

export async function handler(context: Context, req: HttpRequest) {
  const res = { req };
  context.res = {
    status: 200,
    body: JSON.stringify(res),
  };
}
