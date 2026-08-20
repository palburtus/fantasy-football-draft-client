import data2025 from './data_2025.json';
import data2026 from './data_2026.json';

export const availableYears = [2026, 2025];

export const dataByYear = {
    2025: data2025,
    2026: data2026
};

const currentYearOrder = new Map(
    dataByYear[2026].map((player, index) => [player.player_name, index])
);

export const getDataForYear = (year) => {
    const data = dataByYear[year] || [];

    if (Number(year) === 2026) {
        return data.map((player, index) => ({
            ...player,
            displayRank: index + 1
        }));
    }

    const orderedData = data
        .map((player, index) => ({
            player,
            index,
            historicalRank: index + 1,
            currentYearRank: currentYearOrder.has(player.player_name)
                ? currentYearOrder.get(player.player_name) + 1
                : undefined
        }))
        .sort((first, second) => {
            const firstRank = first.currentYearRank ?? Number.MAX_SAFE_INTEGER;
            const secondRank = second.currentYearRank ?? Number.MAX_SAFE_INTEGER;

            return firstRank - secondRank || first.index - second.index;
        });

        return orderedData.map(({ player, historicalRank }) => ({
            ...player,
            displayRank: historicalRank
        }));
};