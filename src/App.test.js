import { render, screen, waitFor } from '@testing-library/react';
import App from './App';
import { getDataForYear } from './yearData';

jest.mock('./firebaseFirestoreRepository', () => ({
  getAllNotes: () => Promise.resolve({ documents: [] }),
  upsertNote: jest.fn()
}));

test('defaults to the 2026 draft view', async () => {
  render(<App />);
  expect(screen.getByLabelText(/^year$/i)).toHaveValue('2026');
  expect(screen.getByRole('option', { name: '2025' })).toBeInTheDocument();
  await waitFor(() => expect(screen.getByLabelText(/^year$/i)).toHaveValue('2026'));
});

test('orders past-year players using the current-year rankings', () => {
  const pastYearPlayers = getDataForYear(2025);

  expect(pastYearPlayers.slice(0, 3).map(player => player.player_name)).toEqual([
    'Jahmyr Gibbs',
    'Bijan Robinson',
    "Ja'Marr Chase"
  ]);
  expect(pastYearPlayers.slice(0, 3).map(player => player.displayRank)).toEqual([4, 2, 1]);
});
