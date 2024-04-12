function selectToArray(select) {
    return select.split(',').map((item) => {
        return item;
    });
}

module.exports = selectToArray;