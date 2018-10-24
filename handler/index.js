module.exports = async function(context, req) {
  const res = { req, env: process.env };
  context.res = {
    body: JSON.stringify(res),
  };
};
