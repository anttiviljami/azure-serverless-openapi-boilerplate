module.exports = async function(context, req) {
  const res = { req };
  context.res = {
    status: 200,
    body: JSON.stringify(res),
  };
};
