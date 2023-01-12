const { describe, test, expect  } = require("@jest/globals")
const aws = require("aws-sdk")

aws.config.update({
    region: "us-east-1"
})

const { main } = require("../../src")
const requestMock = require("../mocks/request.json")
describe("Image analyser test suite", () => {
    test("It should analyse succesfully the image returning results", async () => {
        const finalText = [
            "99.73% de ser do tipo Gatinho",
            "99.73% de ser do tipo gato",
            "99.73% de ser do tipo animal de estimação",
            "99.73% de ser do tipo animal",
            "99.73% de ser do tipo mamífero",
            "98.11% de ser do tipo manx"
        ]
        const expected = {
            statusCode: 200,
            body: "A imagem tem \n".concat(finalText.join("\n"))
        }
        const result = await main(requestMock)
        expect(result).toStrictEqual(expected)
    })
    test("given an empty query string it should return http status code 400", async () => {
        const expected = { 
            statusCode: 400,
            body: "an IMG is required!"
        }

        const result = await main({queryStringParameters: {}})

        expect(result).toStrictEqual(expected)
    })
    test("given an invalid image url it should return http status code 500", async () => {
        const expected = { 
            statusCode: 500,
            body: "Internal server error"
        }

        const result = await main({queryStringParameters: {
            imageUrl: "invalidurl"
        }})

        expect(result).toStrictEqual(expected)
    })
})