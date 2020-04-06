const expect = require("chai").expect;
const request = require("axios");

const baseUrl = process.env.BASE_URL;
console.log("Running tests against baseUrl: ", baseUrl);

describe("E2E Tests", function () {
  describe("GET /heartbeat", function () {
    it("should return a response", function (done) {
      const testUrl = `${baseUrl}/heartbeat`;
      request.get(testUrl).then(response => {
        expect(response.status).to.eq(200);
        expect(response.data).to.eq("Hello");
        done();
      });
    });
  });

  describe("GET /users", function () {
    it("shoudl return the correct response", function (done) {
      const testUrl = `${baseUrl}/users`;
      request.get(testUrl).then(response => {
        expect(response.status).to.eq(200);
        expect(response.data).to.deep.eq({});
        done();
      });
    });
  });
});
