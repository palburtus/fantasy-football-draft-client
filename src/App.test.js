import { render, screen, waitFor } from '@testing-library/react';
import App from './App';

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
