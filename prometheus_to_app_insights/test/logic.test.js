var assert = require('assert');
var Logic = require('../logic');

//var expect = require('chai').expect;
//var should = require('chai').should(); 

describe('Ctor', function () {
    it('\'Logic\' instance is created', function () {
        const logic = new Logic();
        assert.notEqual(logic, null);
    });
});

describe('extractLineValues', function () {
    it('checking extract line values logic from federated line format - valid', function () {
        // assert.notEqual(...);
        const metricName = 'nodejs_heap_space_size_used_bytes';
        const key1 = 'space';
        const val1 = 'large_object';
        const metricValue = '32';
        const timestamp = '1532351918718'
        const validFederatedLine = metricName + '{' + key1 + '="' + val1 + '"} ' + metricValue + ' ' + timestamp;
        const logic = new Logic();
        const results = logic.extractLineValues(validFederatedLine);
        assert.equal(results.metricName, metricName);
        assert.equal(results.value, metricValue);
        assert.equal(results.epoch, timestamp);

        assert.deepEqual(results.customProps, { space: "\"large_object\""});
    });

    describe('extractLineValues', function () {
        it('checking extract line values logic from federated line format - invalid', function () {
            const metricName = ''; // missing on purpose
            const key1 = 'space';
            const val1 = 'large_object';
            const metricValue = '32';
            const timestamp = '1532351918718'
            const validFederatedLine = metricName + '{' + key1 + '="' + val1 + '"} ' + metricValue + ' ' + timestamp;
            const logic = new Logic();
            const results = logic.extractLineValues(validFederatedLine);
            assert.equal(results, null);
        });
    });
});
